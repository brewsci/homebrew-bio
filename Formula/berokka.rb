class Berokka < Formula
  desc "Trim, circularise, and orient long read assemblies"
  homepage "https://github.com/tseemann/berokka"
  url "https://github.com/tseemann/berokka/archive/v0.2.tar.gz"
  sha256 "622786ed7fbd3e397ab9b46de46663ccd7b1830d9a139ae88c4cbb4334779e7c"
  head "https://github.com/tseemann/berokka.git"

  depends_on "bioperl"
  depends_on "blast"
  depends_on "perl" unless OS.mac?

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
