{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "grub-os-prober-2.x";

  src = fetchurl {
    url = "http://git.savannah.gnu.org/gitweb/?p=grub.git;a=blob_plain;h=72fc110d95129410443b898e931ff7a1db75312e;f=util/grub.d/30_os-prober.in";
    sha256 = "0dsxxxvq73885932nafycwdxm9sgyv5qx4x9a47pk9a9g2cc999c";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" "distPhase" ];

  unpackCmd = ''
    stripHash $curSrc
    mkdir os-prober-grub
    cp -prd --no-preserve=timestamps $curSrc os-prober-grub/$strippedName
  '';

  installPhase = ''
    mkdir -p $out/bin
    chmod +x $strippedName
    cp $strippedName $out/bin/os-prober-grub
  '';

  #dontStrip = true;
}
