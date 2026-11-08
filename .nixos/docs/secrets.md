# Secrets with sops-nix

Secrets live encrypted in `secrets/<hostname>.yaml` and are safe to commit. At activation NixOS decrypts each one into `/run/secrets/<name>` (in memory, root-only by default).

## How it works

Each file is encrypted for two age keys, listed in `.sops.yaml`:

| Key | Private key | Used for |
|---|---|---|
| `&admin` (personal) | `~/.config/sops/age/keys.txt` | editing secrets with `sops` |
| `&toaster` (host) | `/etc/ssh/ssh_host_ed25519_key` | decrypting at boot; sops-nix converts it to age itself |

The host key is the machine's SSH *host* key, not your personal `~/.ssh` key.

`common/sops.nix` is imported by `toaster/configuration.nix`. It also builds `sops-install-secrets` with Go 1.26, because sops-nix needs it and nixpkgs 25.11 defaults to 1.25. Remove that override once the default `go` is 1.26 or newer.

## Backups

- **Store `~/.config/sops/age/keys.txt` in the password manager.** It is the master key.
- The host key is optional to back up. Without it, re-key after a reinstall (see below).

## Add or change a secret

1. Edit the encrypted file:

   ```sh
   nix shell nixpkgs#sops -c sops secrets/toaster.yaml
   ```

   ```yaml
   my_token: abc123
   ```

2. Declare it in `common/sops.nix` (name must match the YAML key):

   ```nix
   secrets = {
     test_secret = { };
     my_token = { owner = "liamederzeel"; };  # owner only if a non-root user must read it
   };
   ```

3. Rebuild and check:

   ```sh
   sudo nixos-rebuild switch --flake ~/.nixos#toaster
   sudo cat /run/secrets/my_token
   ```

`test_secret` is a working example. Delete it from both files when no longer wanted.

## Use a secret

Reference the file path, never the value. Values in Nix expressions end up world-readable in `/nix/store`.

```nix
services.something.passwordFile = config.sops.secrets.my_token.path;  # /run/secrets/my_token
```

To build a whole config file from several secrets, use a template:

```nix
sops.templates."app.env" = {
  owner = "liamederzeel";
  content = ''
    TOKEN=${config.sops.placeholder.my_token}
  '';
};
# path: config.sops.templates."app.env".path
```

## Add another machine (lisa, lab1)

1. On that machine, get its age public key:

   ```sh
   nix shell nixpkgs#ssh-to-age -c ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
   ```

2. In `.sops.yaml`, add the key and a creation rule:

   ```yaml
   keys:
     - &lisa age1...
   creation_rules:
     - path_regex: secrets/lisa\.yaml$
       key_groups:
         - age: [*admin, *lisa]
   ```

3. Create `secrets/lisa.yaml` with `sops`, add `sops-nix.nixosModules.sops` to that host's modules in `flake.nix`, and import `../common/sops.nix` in its `configuration.nix`.

## Re-key (reinstall, new host key, new admin key)

After changing keys in `.sops.yaml`:

```sh
nix shell nixpkgs#sops -c sops updatekeys secrets/toaster.yaml
```

This needs a key that can still decrypt the file, normally your personal age key.

## Recover on a new or reinstalled machine

A fresh install has a new SSH host key, so it can't decrypt the existing secrets until you update them. Your personal age key is what makes recovery possible.

1. **Restore the personal age key** from the password manager:

   ```sh
   mkdir -p ~/.config/sops/age
   # paste the full contents of the saved note into:
   $EDITOR ~/.config/sops/age/keys.txt
   chmod 600 ~/.config/sops/age/keys.txt
   ```

2. **Get this repo onto the machine**, e.g. as `~/.nixos`.

3. **Pick one:**

   **A. Restore the old host key** (only if you backed it up). No re-keying needed:

   ```sh
   sudo install -m 600 -o root old_host_key /etc/ssh/ssh_host_ed25519_key
   sudo install -m 644 -o root old_host_key.pub /etc/ssh/ssh_host_ed25519_key.pub
   ```

   **B. Use the new host key** (the usual case):

   ```sh
   nix shell nixpkgs#ssh-to-age -c ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
   ```

   Replace the `&toaster` key in `.sops.yaml` with that output, then:

   ```sh
   nix shell nixpkgs#sops -c sops updatekeys secrets/toaster.yaml
   ```

4. **Rebuild** and verify:

   ```sh
   sudo nixos-rebuild switch --flake ~/.nixos#toaster
   sudo cat /run/secrets/test_secret
   ```

Notes:
- The host key only exists once sshd has run once (enable `services.openssh` or boot a standard installer). If `/etc/ssh/ssh_host_ed25519_key` is missing, the rebuild can't decrypt anything.
- A secrets file is named after `networking.hostName`. A machine with a different hostname needs its own `secrets/<hostname>.yaml` and creation rule (see "Add another machine").
- If you lose the personal age key **and** the old host key, the secrets can't be decrypted. Re-enter the values from their original source into a new file.

## Troubleshooting

- **Can't decrypt when editing:** check that `~/.config/sops/age/keys.txt` exists, or set `SOPS_AGE_KEY_FILE`.
- **Rebuild says a key doesn't exist in the file:** the name in `common/sops.nix` doesn't match the YAML key.
- **`go.mod requires go >= 1.26`:** the `sops.package` override in `common/sops.nix` is missing.
- **Never** commit plaintext secrets or paste values into `.nix` files.
