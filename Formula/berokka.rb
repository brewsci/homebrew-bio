class Berokka < Formula
  desc "Trim, circularise, and orient long read assemblies"
  homepage "https://github.com/tseemann/berokka"
  url "https://github.com/tseemann/berokka/archive/v0.2.3.tar.gz"
  sha256 "460f4272768e205008aa8aa885d1df5bab9af2c5b404c261e00573c6a30a641f"
  license "GPL-3.0"
  revision 1
  head "https://github.com/tseemann/berokka.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "a3059b1c5cc90f4bcd9ea1d13dfe0e8cf10e5d9493f1814cfc69e8b5c466215c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f64bd4240a6c221748151e18de43a5d379d6da5f23366331a3dc3993241e99b"
  end

  depends_on "bioperl"
  depends_on "blast"

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
