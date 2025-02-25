class ConformGt < Formula
  desc "Modify target VCF so that its records are consistent with reference VCF"
  homepage "https://faculty.washington.edu/browning/conform-gt.html"
  url "https://faculty.washington.edu/browning/conform-gt/conform-gt.24May16.cee.src.zip"
  version "24May16"
  sha256 "fb9daa6008dbdc3e130caf7abd123c63f875c6f9189a76ce00fe846f4c6ba489"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "9e33a49a487934e8ec04cf62d06f417b3a7e3b6442434ee32b7742c91225e874"
  end

  depends_on "openjdk"

  def install
    chdir ".." do
      system "#{Formula["openjdk"].bin}/javac", "-cp", "src/", "src/conform/ConformMain.java"
      system "#{Formula["openjdk"].bin}/jar", "-cfe", "conform-gt.jar", "conform.ConformMain", "-C", "src/", "."

      libexec.install "conform-gt.jar"
      bin.write_jar_script libexec/"conform-gt.jar", "conform-gt"
    end
  end

  test do
    assert_predicate bin/"conform-gt", :executable?
    assert_path_exists libexec/"conform-gt.jar"
    assert_match "usage: java -jar conform-gt.", shell_output("#{bin}/conform-gt")
  end
end
