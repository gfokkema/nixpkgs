{ stdenv, fetchurl, bash }:

let
  base = "os-prober";
  version = "1.71";
in
stdenv.mkDerivation {
  name = "${base}-${version}";
  dataDir = "/var/lib/os-prober";

  src = fetchurl {
    url = "ftp://ftp.debian.org/debian/pool/main/o/${base}/${base}_${version}.tar.xz";
    sha256 = "086x7cv7lbjxbw2jz76qfn0zfzqwss1xd5rb8aa23s2q5gh42qax";
  };

  buildInputs = [ bash ];

  patchPhase = ''
    for file in $(find -type f); do
      substituteInPlace $file \
        --replace /bin/sh $shell \
        --replace /usr/share/os-prober $out/share/os-prober \
        --replace /usr/lib/os-prober $out/lib/os-prober \
        --replace /usr/lib/os-probes $out/lib/os-probes \
        --replace /usr/lib/linux-boot-probes $out/lib/linux-boot-probes
    done
  '';

  buildPhase = ''
    make newns
  '';

  installPhase = ''
    install -Dm755 linux-boot-prober "$out/bin/linux-boot-prober"
    install -Dm755 os-prober         "$out/bin/os-prober"
    install -Dm755 newns             "$out/lib/os-prober/newns"
    install -Dm755 common.sh         "$out/share/os-prober/common.sh"
  
    for dir in os-probes os-probes/mounted os-probes/init linux-boot-probes linux-boot-probes/mounted; do
      install -dm755                 "$out/lib/$dir"
      install -m755 -t               "$out/lib/$dir" "$dir/common/"*

      [[ -d "$dir/x86" ]] && cp -r "$dir/x86/"* "$out/lib/$dir"
    done
  
    install -Dm755 os-probes/mounted/powerpc/20macosx "$out/lib/os-probes/mounted/20macosx"
  '';

  meta = {
    description = "Utility to detect other OSes on a set of drives";
    homepage = "http://joey.kitenet.net/code/os-prober/";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ "Gerlof Fokkema" ];
    platforms = stdenv.lib.platforms.linux;
  };
}
