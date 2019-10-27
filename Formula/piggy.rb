class Piggy < Formula
  # cite Thorpe_2018: "https://doi.org/10.1093/gigascience/giy015"
  desc "Analysis of intergenic regions in bacterial genomes"
  homepage "https://github.com/harry-thorpe/piggy"
  url "https://github.com/harry-thorpe/piggy/archive/v1.5.tar.gz"
  sha256 "f0c6e51f6d38325de857ca8524eca8cbecf295653d8a2cb52e61678e6206e57a"

  depends_on "roary"
  
  uses_from_macos "perl"

  def install
    prefix.install Dir["*"]
  end

  test do
    exe = "#{bin}/piggy"
    assert_match version.to_s, shell_output("#{exe} --version 2>&1")
    assert_match "IGR", shell_output("#{exe} --help 2>&1")
  end
end
