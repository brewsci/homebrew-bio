class Rails < Formula
  # cite Warren_2016: "https://doi.org/10.21105/joss.00116"
  desc "Scaffolding and gap-filling with long sequences: RAILS and Cobbler"
  homepage "https://github.com/bcgsc/RAILS"
  url "https://github.com/bcgsc/RAILS/archive/v1.5.1.tar.gz"
  sha256 "ec7307df042bd3fad2d99d0e89039a661f3fb613f3f26adcd5d481ed1cb94996"
  head "https://github.com/bcgsc/RAILS.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "fc856b3dfd390d14f054bc8a80093759f3c486c639275626af67ed44d2aa55ee" => :sierra
    sha256 "4fe32dcd616749cbba8c0dbb111eb6d12ba80d656753a103c2e78901e4fced2b" => :x86_64_linux
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
