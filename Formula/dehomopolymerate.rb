class Dehomopolymerate < Formula
  desc "Collapse homopolymer runs in FASTQ files"
  homepage "https://github.com/tseemann/dehomopolymerate"
  url "https://github.com/tseemann/dehomopolymerate/archive/v0.3.tar.gz"
  sha256 "659778bc7cd8e52a92f1547b5a93e71bf8022f62208313d06aec454aad9e91d6"

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "dehomopolymerate"
    pkgshare.install "test"
  end

  test do
    exe = bin/"dehomopolymerate"
    assert_match version.to_s, shell_output("#{exe} -v")
    assert_match "Collapse", shell_output("#{exe} -h")
    assert_match "avglen=90", shell_output("#{exe} -w #{pkgshare}/test/test.fq.gz 2>&1")
  end
end
