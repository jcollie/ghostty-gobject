# generated by zon2nix (https://github.com/jcollie/zon2nix)
{
  lib,
  linkFarm,
  fetchurl,
  fetchgit,
  runCommandLocal,
  zig_0_14,
  name ? "zig-packages",
}:
let
  unpackZigArtifact =
    {
      name,
      artifact,
    }:
    runCommandLocal name
      {
        nativeBuildInputs = [ zig_0_14 ];
      }
      ''
        hash="$(zig fetch --global-cache-dir "$TMPDIR" ${artifact})"
        mv "$TMPDIR/p/$hash" "$out"
        chmod 755 "$out"
      '';

  fetchZig =
    {
      name,
      url,
      hash,
    }:
    let
      artifact = fetchurl { inherit url hash; };
    in
    unpackZigArtifact { inherit name artifact; };

  fetchGitZig =
    {
      name,
      url,
      hash,
    }:
    let
      parts = lib.splitString "#" url;
      url_base = builtins.elemAt parts 0;
      url_without_query = builtins.elemAt (lib.splitString "?" url_base) 0;
      rev_base = builtins.elemAt parts 1;
      rev =
        if builtins.match "^[a-fA-F0-9]{40}$" rev_base != null then
          rev_base
        else
          "refs/heads/${rev_base}";
    in
    fetchgit {
      inherit name rev hash;
      url = url_without_query;
      deepClone = false;
    };

  fetchZigArtifact =
    {
      name,
      url,
      hash,
    }:
    let
      parts = lib.splitString "://" url;
      proto = builtins.elemAt parts 0;
      path = builtins.elemAt parts 1;
      fetcher = {
        "git+http" = fetchGitZig {
          inherit name hash;
          url = "http://${path}";
        };
        "git+https" = fetchGitZig {
          inherit name hash;
          url = "https://${path}";
        };
        http = fetchZig {
          inherit name hash;
          url = "http://${path}";
        };
        https = fetchZig {
          inherit name hash;
          url = "https://${path}";
        };
      };
    in
    fetcher.${proto};
in
linkFarm name [
  {
    name = "xml-0.1.0-ZTbP3_47AgClPn_55oc3J5FaewBcphmzZifp-vLd5WpG";
    path = fetchZigArtifact {
      name = "xml";
      url = "git+https://github.com/ianprime0509/zig-xml?ref=main#7c1697f35065ab54088d268ef52abf4c53dc7d62";
      hash = "sha256-u31MXnl7gdQn0P78wt4l4+mGY15LxMx1KRv7kFL/d68=";
    };
  }
  {
    name = "gobject_codegen-0.2.2-B33qzby7BgB8fsoAiF7N5dKEHGNd7t48tvQ44M1EXnOR";
    path = fetchZigArtifact {
      name = "zig_gobject";
      url = "https://github.com/ianprime0509/zig-gobject/archive/1f11f093ddb07ab333c7ae03b4fc8ad5456934b3.tar.gz";
      hash = "sha256-ckZxgYziKXW9rIS7R1xV43SOm8L9sr00VoRTWxhy2vI=";
    };
  }
]
