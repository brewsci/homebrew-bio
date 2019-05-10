class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  url "https://github.com/broadinstitute/pilon/releases/download/v1.23/pilon-1.23.jar"
  sha256 "bde1d3c8da5537abbc80627f0b2a4165c2b68551690e5733a6adf62413b87185"
  head "https://github.com/broadinstitute/pilon.git"
  # cite Walker_2014: "https://doi.org/10.1371/journal.pone.0112963"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "79b1480bd485ebb3985db93d8361d68b7f5408c586f127f285288de3d7781efc" => :sierra
  end

  depends_on :java

  def install
    opts = "-Xmx1000m -Xms20m"
    jar = "pilon-#{version}.jar"
    prefix.install jar
    bin.write_jar_script prefix/jar, "pilon", opts
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pilon --help")
  end
end
