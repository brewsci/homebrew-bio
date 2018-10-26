class Jspecies < Formula
  # cite Richter_2009: "https://doi.org/10.1073/pnas.0906412106"
  desc "Average Nucleotide Idenity for species boundaries"
  homepage "https://imedea.uib-csic.es/jspecies/index.html"
  url "https://imedea.uib-csic.es/jspecies/jars/jspecies1.2.1.jar"
  sha256 "6820b60413fec2e0df128a9c9815d2e057429a42346fe6cb237330b49069eb66"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fdad5b757d32a71e196a65e6b241d30472e55c16634e0f7e777f840817bc8cc9" => :sierra
  end

  depends_on :java

  depends_on "blast-legacy"
  depends_on "mummer"

  def install
    jar = "jspecies#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "jspecies"
  end

  test do
    # No test because this is a GUI
  end
end
