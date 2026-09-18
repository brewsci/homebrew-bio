class Subread < Formula
  # cite Liao_2013: "https://doi.org/10.1093/nar/gkt214"
  desc "High-performance read alignment, quantification and mutation discovery"
  homepage "https://academic.oup.com/nar/article/41/10/e108/1075719"
  url "https://cfhcable.dl.sourceforge.net/project/subread/subread-2.1.1/subread-2.1.1-source.tar.gz"
  sha256 "6392d7c66831cdd767e58251892a79a51b6fab8ed0ba9671ad5e85ff1ab01eaa"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "f763ea04f616a72c4b61b04ea345a8577f283b0da29d91714241b70e3b0705f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "96a086816e5094e5ff5c2ae7d4f11a0f8e8764afaac7568bdaecaee0f37c9b0d"
  end

  uses_from_macos "zlib"

  def install
    cd "src" do
      if OS.mac?
        system "make", "-f", "Makefile.MacOS"
      else
        system "make", "-f", "Makefile.Linux"
      end

      bin.install Dir["../bin/sub*"]
      bin.install "../bin/exactSNP"
      bin.install "../bin/featureCounts"
      bin.install Dir["../bin/utilities/*"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/featureCounts -v 2>&1")
  end
end
