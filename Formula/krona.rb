class Krona < Formula
  # cite Ondov_2011: "https://doi.org/10.1186/1471-2105-12-385"
  desc "Interactively explore metagenomes and more from a web browser"
  homepage "https://github.com/marbl/Krona/wiki"
  url "https://github.com/marbl/Krona/releases/download/v2.8.1/KronaTools-2.8.1.tar"
  sha256 "f3ab44bf172e1f846e8977c7443d2e0c9676b421b26c50e91fa996d70a6bfd10"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64e74caf6fd0629903d377ae0e86ad839d3db19614dfd6936baf4e78a68f8f45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64e74caf6fd0629903d377ae0e86ad839d3db19614dfd6936baf4e78a68f8f45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64e74caf6fd0629903d377ae0e86ad839d3db19614dfd6936baf4e78a68f8f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "836673a48ced959e4b6c1c6631a7bab1e671455f029143a95958261e2b6adfab"
  end

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
