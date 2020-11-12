class Solexaqa < Formula
  # cite Cox_2010: "https://doi.org/10.1186/1471-2105-11-485"
  desc "Quality statistics for second-generation sequencing data"
  homepage "https://solexaqa.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/solexaqa/src/SolexaQA%2B%2B_v3.1.7.1.zip"
  sha256 "b3bdabf955387a4f6176dbdfda1cf03bb869c077b4eec152304f2e76be5f0cf6"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "bb6cc746542b42234d0444bf2ae13bd3d7360e11c4582687bac2c30d7e167188" => :sierra
    sha256 "f3618d54e63db3fda2e442d2a8a38afb1db0c2c7f695e2e1013ae6cef1e86ff2" => :x86_64_linux
  end

  depends_on "boost" => :build

  def install
    cd "source" do
      system "make"
      bin.install "SolexaQA++"
    end
  end

  test do
    assert_match "dynamictrim", shell_output("#{bin}/SolexaQA++ 2>&1", 1)
  end
end
