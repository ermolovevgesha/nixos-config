{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, makeWrapper
, openssl
, src ? null
}:

let
  resolvedSrc = if src != null then src else fetchFromGitHub {
    owner = "confeden";
    repo  = "Antigravity";
    rev   = "main";
    hash  = lib.fakeHash;
  };
in

rustPlatform.buildRustPackage {
  pname   = "ag-unlocker";
  version = "2.22.0";

  src = resolvedSrc;

  cargoLock = {
    lockFile = "${resolvedSrc}/Cargo.lock";
  };

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
    wrapProgram $out/bin/ag_unlocker \
      --add-flags "--tui"
  '';

  meta = with lib; {
    description = "Antigravity Unlocker (TUI only)";
    homepage    = "https://github.com/confeden/Antigravity";
    license     = licenses.unfreeRedistributable;
     platforms  = platforms.linux;
    mainProgram = "ag_unlocker";
  };
}