class Jspecies < Formula
  # cite Richter_2009: "https://doi.org/10.1073/pnas.0906412106"
  desc "Average Nucleotide Idenity for species boundaries"
  homepage "https://imedea.uib-csic.es/jspecies/index.html"
  url "https://imedea.uib-csic.es/jspecies/jars/jspecies1.2.1.jar"
  sha256 "6820b60413fec2e0df128a9c9815d2e057429a42346fe6cb237330b49069eb66"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, sierra: "fdad5b757d32a71e196a65e6b241d30472e55c16634e0f7e777f840817bc8cc9"
  end

  depends_on "brewsci/bio/blast-legacy"
  depends_on "brewsci/bio/mummer"
  depends_on "openjdk"

  def install
    jar = "jspecies#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "jspecies"
  end

  test do
    # No test because this is a GUI
    nil
  end
end
