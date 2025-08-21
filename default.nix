{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
 src = fetchFromGitHub {
  owner = "pietern";
  repo = "goestools";
  rev = "80ece1a";
  sha256 = "sha256-qrtLiS1nFsGIFrazitLQetrEPiMP5SbBSbwp0bPhCV0=";
  fetchSubmodules = true;
 };

 astralixConfig = fetchFromGitHub {
  owner = "cadenmr";
  repo = "goes_config";
  rev = "3051957";
  sha256 = "sha256-5F1Zhcqug7J7qEIiKanQiGrwawnLyO+bmbfUj60TPKY=";
 };

in
stdenv.mkDerivation rec {

 inherit src;
 inherit astralixConfig;

 pname = "goestools";
 version = src.rev;

 nativeBuildInputs = [
  pkg-config
  cmake
  opencv
  zlib
  rtl-sdr
  proj
  sqlite
  libtiff
  lerc
  curlWithGnuTls
  libtasn1
  p11-kit
 ];

 postInstall = ''

  substitute $astralixConfig/goesproc-goesn.conf $out/share/goestools/goesproc-goesn.conf \
   --replace "/usr/local/share/goestools" "$out/share/goestools"  

  substitute $astralixConfig/goesproc-goesr.conf $out/share/goestools/goesproc-goesr.conf \
   --replace "/usr/local/share/goestools" "$out/share/goestools"

  cp $astralixConfig/goesrecv.conf $out/share/goestools
 '';

}
