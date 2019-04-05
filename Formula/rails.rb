class Rails < Formula
  # cite L_Warren_2016: "https://doi.org/10.21105/joss.00116"
  desc "Scaffolding and gap-filling with long sequences: RAILS and Cobbler"
  homepage "https://github.com/bcgsc/RAILS"
  url "https://github.com/bcgsc/RAILS/archive/v1.4.1.tar.gz"
  sha256 "21d5a0ae1cdcc23b9544c89d47f66d99f2d060da5ba9d7fdb2753502e53be6d8"
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
