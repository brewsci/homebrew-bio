class Gblocks < Formula
  # cite Castresana_2000: "https://doi.org/10.1093/oxfordjournals.molbev.a026334"
  desc "Select conserved blocks from multiple alignments"
  homepage "http://molevol.cmima.csic.es/castresana/Gblocks.html"
  if OS.mac?
    url "http://molevol.cmima.csic.es/castresana/Gblocks/Gblocks_OSX_0.91b.tar.Z"
    sha256 "e5b9e1ae2a227ca0b78ca65741e44f460c7968dea4b01ea45150b1231f391473"
  else
    url "http://molevol.cmima.csic.es/castresana/Gblocks/Gblocks_Linux64_0.91b.tar.Z"
    sha256 "563658f03cc5e76234a8aa705bdc149398defec813d3a0c172b5f94c06c880dc"
  end
  version "0.91b"

  depends_on "patchelf" => :build unless OS.mac?

  def install
    exe = "Gblocks"
    bin.install exe
    if OS.linux?
      system "patchelf",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX/"lib",
        bin/exe
    end
    doc.install "Documentation/Gblocks_documentation.html"
    pkgshare.install Dir["*.pir"], Dir["more_alignments/*.pir"]
  end

  test do
    assert_match version.to_s, shell_output("echo 'q' | #{bin}/Gblocks", 1)
  end
end
