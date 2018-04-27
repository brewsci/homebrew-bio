class TransAbyss < Formula
  # cite Robertson_2015: "https://doi.org/10.1038/nmeth.1517"
  desc "Assemble RNA-Seq data using ABySS"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss"

  url "https://github.com/bcgsc/transabyss/archive/1.5.5.tar.gz"
  sha256 "e3e92661a97ac9f7e097182a1040675bc5a334253ed098898411f3952bddebe3"

  depends_on "abyss"
  depends_on "blat"
  depends_on "bowtie2"
  depends_on "gmap-gsnap"
  depends_on "igraph"
  depends_on "picard-tools"
  depends_on "samtools"

  # Depends_on "pysam" => :python
  # Depends_on LanguageModuleRequirement.new :python, "biopython", "Bio"
  # Depends_on LanguageModuleRequirement.new :python, "python-igraph", "igraph"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../transabyss", "../transabyss-merge"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/transabyss --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/transabyss-merge --help 2>&1")
  end
end
