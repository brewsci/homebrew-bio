class Solexaqaxx < Formula
  desc "Quality statistics for second-generation sequencing data"
  homepage "https://sourceforge.net/projects/solexaqa"
  # doi "10.1186/1471-2105-11-485"
  # tag "bioinformatics"
  url "https://downloads.sourceforge.net/project/solexaqa/src/SolexaQA%2B%2B_v3.1.7.1.zip"
  sha256 "b3bdabf955387a4f6176dbdfda1cf03bb869c077b4eec152304f2e76be5f0cf6"

  depends_on "boost" => :build

  def install
    cd "source" do
      system "make"
      bin.install "SolexaQA++"
    end
  end

  test do
    assert_match "dynamictrim", shell_output("#{bin}/SolexaQA++ 2>&1 || true")
  end
end
