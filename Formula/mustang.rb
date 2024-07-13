class Mustang < Formula
  # cite Konagurthu_2006: "https://doi.org/10.1002/prot.20921"
  desc "Multiple structural alignment algorithm"
  homepage "https://lcb.infotech.monash.edu/mustang/"
  url "https://lcb.infotech.monash.edu/mustang/mustang_v3.2.4.tgz"
  sha256 "c05e91c955f491a1fddc404a36ef963b057fd725bcc6d22ef6df1c23b26ce237"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "466f19e29390334352ef8b330dd0f5c54e211dcff02a62ca7eea507f600aec86"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "defaa2d7344845564154baa2e2bf6ffaecb4186936cca25e620926017d3f09f9"
  end

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "-traditional", "" if OS.mac?
    inreplace "Makefile", "mustang-#{version.to_s}", "mustang"
    system "make"
    bin.install "bin/mustang"
    man1.install "man/mustang.1"
  end

  test do
    assert_match "A MUltiple STuructural", shell_output("#{bin}/mustang --help")
  end
end
