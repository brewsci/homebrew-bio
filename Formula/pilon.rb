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
    sha256 "0a36e64ea157912c9e47c0098a710080c549d06a55502dbe4c2972bebd6ec3db" => :sierra
    sha256 "37157f6eb70104f6d4cd972c995db5004988295f349126f6208ce584345ff6ba" => :x86_64_linux
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
