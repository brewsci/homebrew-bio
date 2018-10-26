class Bazam < Formula
  # Sadedin_2018: "https://doi.org/10.1101/433003"
  desc "Extract paired reads from coordinate sorted BAM files"
  homepage "https://github.com/ssadedin/bazam"
  url "https://github.com/ssadedin/bazam/releases/download/1.0.1/bazam.jar"
  sha256 "396e584c95e2184025f9b9eca7377c376894f3afb4572856387866ab59c741e8"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "5fc4d9196cfaa7f87e40383c830ef220b0a0a76028c68ae03a3f0d48d1de5120" => :sierra
    sha256 "08d9d9e0560074dafa59cc6347fa714d717bdefe69cf90f88ce017ead1344919" => :x86_64_linux
  end

  depends_on :java

  def install
    jar = "bazam.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "bazam"
  end

  test do
    # https://github.com/ssadedin/bazam/issues/5
    assert_match "Groovy", shell_output("#{bin}/bazam -h 2>&1", 1)
  end
end
