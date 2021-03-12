with import <nixpkgs> {};
stdenv.mkDerivation rec {
  pname = "footswitch";
  version = "0.1";
  inherit gnumake gcc;
  buildInputs = [ pkgs.hidapi ];
  nativeBuildInputs = [ gcc pkgconfig makeWrapper coreutils ];
  # run-time dependencies propagated to other dependent derivations on this derivation
  # for example Python library dependent on another Python library
  # Python program using some library is dependent also on all dependencies of this libraries
  propagatedBuildInputs = [ pkgs.hidapi ];

  shellHook = ''
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${pkgs.hidapi}/lib/pkgconfig"
  '';

  src = builtins.fetchGit {
      url = "https://github.com/elmarsto/footswitch";
      ref = "master";
    };

  # specify configurePhase, buildPhase, ...
  buildPhase = ''
    make
  '';

  # specify output of derivation
  installPhase = ''
    mkdir -p $out/bin
    cp footswitch $out/bin/footswitch
    mkdir -p $out/lib/udev/rules.d/
    cp 19-footswitch.rules $out/lib/udev/rules.d/
  '';

  # provide some package attributes, for example executable name
  passthru = {
    executable = pname;
  };

  system = builtins.currentSystem;

  meta = with stdenv.lib; {
    description = "Footswitch";
    longDescription = ''
      For PCSensor pedal.
    '';
    homepage = "https://github.com/rgerganov/footswitch";
    license = licenses.mit;
    # maintainers are registred in Nixpkgs repository
    maintainers = [];
    platforms = platforms.all;
  };
}

