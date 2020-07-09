class Dehomopolymerate < Formula
  desc "Collapse homopolymer runs in FASTQ files"
  homepage "https://github.com/tseemann/dehomopolymerate"
  url "https://github.com/tseemann/dehomopolymerate/archive/v0.4.0.tar.gz"
  sha256 "89b825e8092600cd8a81c81db6b40c1f206ea6b0f1853a15185aefaf24d02383"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "eec3e8a9cae2c1b5abcaa84400de8cdc2d97ff5fe5fe212edd205058f852cde7" => :sierra
    sha256 "7033066df34fa9c415916469fe8a9c97e7bea45c4bb1c70b303044d4746e13a0" => :x86_64_linux
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
