class Rails < Formula
  # cite Warren_2016: "https://doi.org/10.21105/joss.00116"
  desc "Scaffolding and gap-filling with long sequences: RAILS and Cobbler"
  homepage "https://github.com/bcgsc/RAILS"
  url "https://github.com/bcgsc/RAILS/archive/v1.4.2.tar.gz"
  sha256 "1da9ca0899e967472dec936b50fdbf649024d7ac226fd786224479d860dc55ea"
  head "https://github.com/bcgsc/RAILS.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "d40a0006cb6fd302f9467d1bd957f94a4ffeed8caf59ca777bef3ea43f0ddc88" => :sierra
    sha256 "d8596e415a173476130e987c64a746e83c88b11e3b4811c0e802db9d84c03ffc" => :x86_64_linux
  end

  depends_on "bwa"
  depends_on "perl"
  depends_on "samtools"

  def install
    inreplace "bin/RAILS", "/usr/bin/env perl", Formula["perl"].bin/"perl"
    inreplace "bin/cobbler.pl", "/usr/bin/env perl", Formula["perl"].bin/"perl"
    bin.install Dir["bin/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/RAILS", 255)
    assert_match "Usage", shell_output("#{bin}/cobbler.pl", 255)
    assert_match "Usage", shell_output("#{bin}/runRAILS.sh", 1)
  end
end
