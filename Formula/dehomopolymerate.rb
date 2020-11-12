class Dehomopolymerate < Formula
  desc "Collapse homopolymer runs in FASTQ files"
  homepage "https://github.com/tseemann/dehomopolymerate"
  url "https://github.com/tseemann/dehomopolymerate/archive/v0.4.0.tar.gz"
  sha256 "89b825e8092600cd8a81c81db6b40c1f206ea6b0f1853a15185aefaf24d02383"
  license "GPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "21e7a971ea6a8657b9634f108e98e52bcf42ef2af5952cbff9cedc737328a25b" => :catalina
    sha256 "2d12702c3ae4fb608e1e85f69aab2bc2d4e0a858f385668de16fdb3fab6e918c" => :x86_64_linux
  end

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
