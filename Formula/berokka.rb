class Berokka < Formula
  desc "Trim, circularise, and orient long read assemblies"
  homepage "https://github.com/tseemann/berokka"
  url "https://github.com/tseemann/berokka/archive/v0.2.tar.gz"
  sha256 "622786ed7fbd3e397ab9b46de46663ccd7b1830d9a139ae88c4cbb4334779e7c"
  head "https://github.com/tseemann/berokka.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f93bff2ca6572ef70c7282b1821a186f278b9320e4fac37e7eb60c87c7d27a15" => :sierra
    sha256 "90c1e666295c95869598887b3b3d18e0293b24f372fe596adfff38db9a79e9d8" => :x86_64_linux
  end

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
