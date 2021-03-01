class Berokka < Formula
  desc "Trim, circularise, and orient long read assemblies"
  homepage "https://github.com/tseemann/berokka"
  url "https://github.com/tseemann/berokka/archive/v0.2.3.tar.gz"
  sha256 "460f4272768e205008aa8aa885d1df5bab9af2c5b404c261e00573c6a30a641f"
  license "GPL-3.0"
  head "https://github.com/tseemann/berokka.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "90c798a58c208954333c4cc029603a7fa27a906314fedd8a73e508619c234896"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c1b33a40dc324edcaa1cd2cebcb223fa0f9e24ef443cc7b426454ef1bff3893b"
  end

  depends_on "blast"
  depends_on "brewsci/bio/bioperl"

  uses_from_macos "perl"

  def install
    bioperl = Formula["bioperl"].libexec/"lib/perl5"
    inreplace "bin/berokka", "use strict;\n", "use strict;\nuse lib '#{bioperl}';\n"
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berokka --version")
    system "#{bin}/berokka", "--check"
  end
end
