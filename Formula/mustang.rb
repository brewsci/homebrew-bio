class Mustang < Formula
  # cite Konagurthu_2006: "https://doi.org/10.1002/prot.20921"
  desc "Multiple structural alignment algorithm"
  homepage "https://lcb.infotech.monash.edu/mustang/"
  url "https://lcb.infotech.monash.edu/mustang/mustang_v3.2.3.tgz"
  sha256 "f1c8d64acc04c70e30b3128c370e485438eb38db96b1b3180d31eaa24a52704a"
  license "BSD-3-Clause"

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "-traditional", "" if OS.mac?
    inreplace "Makefile", "mustang-3.2.3", "mustang"
    system "make"
    bin.install "bin/mustang"
    man1.install "man/mustang.1"
  end

  test do
    assert_match "A MUltiple STuructural", shell_output("#{bin}/mustang --help")
  end
end
