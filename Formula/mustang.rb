class Mustang < Formula
  # cite Konagurthu_2006: "https://doi.org/10.1002/prot.20921"
  desc "Multiple structural alignment algorithm"
  homepage "https://lcb.infotech.monash.edu/mustang/"
  url "https://lcb.infotech.monash.edu/mustang/mustang_v3.2.4.tgz"
  sha256 "c05e91c955f491a1fddc404a36ef963b057fd725bcc6d22ef6df1c23b26ce237"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "e187a53e032999b93b28e66bd1d12de37a6866e8fe97e676da055c720898da1f"
    sha256 cellar: :any_skip_relocation, ventura:      "67eea2a7c4fbeffbb131cbd483eee700909a2853184d3bea7f9d0cde79be0615"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b10e645c5cd899f971d8e1ceba0f00fcfe2f7f7933675c039c5fedda340f5f1c"
  end

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "-traditional", "" if OS.mac?
    inreplace "Makefile", "mustang-#{version}", "mustang"
    system "make"
    bin.install "bin/mustang"
    man1.install "man/mustang.1"
  end

  test do
    assert_match "A MUltiple STuructural", shell_output("#{bin}/mustang --help")
  end
end
