class Krona < Formula
  # cite Ondov_2011: "https://doi.org/10.1186/1471-2105-12-385"
  desc "Interactively explore metagenomes and more from a web browser"
  homepage "https://github.com/marbl/Krona/wiki"
  url "https://github.com/marbl/Krona/releases/download/v2.8/KronaTools-2.8.tar"
  sha256 "56efc028b6226a1aea8ec4e9f049836b07d4833e7e4d5b9189118ed51a47c9c0"
  license "BSD-3-Clause"

  def install
    prefix.install %w[data img lib src taxonomy scripts], Dir["*.sh"]
    scripts = prefix/"scripts"
    Dir[scripts/"*.pl"].each do |i|
      base = File.basename(i, ".pl")
      mv scripts/"#{base}.pl", scripts/"kt#{base}"
      bin.install_symlink scripts/"kt#{base}"
    end
  end

  def caveats
    <<~CAV
      To use scripts that rely on NCBI taxonomy, run:
          #{prefix}/updateTaxonomy.sh
      To use scripts that get taxonomy IDs from accessions, run:
          #{prefix}/updateAccessions.sh
    CAV
  end

  test do
    assert_equal lib.to_s, shell_output(bin/"ktGetLibPath")
  end
end
