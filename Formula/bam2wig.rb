class Bam2wig < Formula
  desc "Generating read coverage profile (WIG file) from a BAM file"
  homepage "http://www.epigenomes.ca/tools-and-software"
  url "http://www.epigenomes.ca/resources/BAM2WIG/BAM2WIG-1.0.0.jar"
  sha256 "133f961de9f394973322ac7b3f01622fcc85a6e29c697c2df3652e8cf0aa690e"

  bottle :unneeded

  depends_on :java

  def install
    java = share/"java"
    java.install Dir["*.jar"]
    bin.write_jar_script java/"BAM2WIG-1.0.0.jar", "bam2wig"
  end

  def caveats
    <<~EOS
      The BAM2WIG JAR files are installed to
        #{HOMEBREW_PREFIX}/share/java
    EOS
  end

  test do
    assert_match "Usage", shell_output("java -jar #{share}/java/BAM2WIG-1.0.0.jar")
    assert_match "Usage", shell_output("#{bin}/bam2wig")
  end
end
