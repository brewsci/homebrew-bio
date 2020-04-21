class Gatk < Formula
  include Language::Python::Shebang

  # cite McKenna_2010: "https://doi.org/10.1101/gr.107524.110"
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://software.broadinstitute.org/gatk"
  url "https://github.com/broadinstitute/gatk/releases/download/4.1.6.0/gatk-4.1.6.0.zip"
  sha256 "1a8a0256693c0e1fb83d87b6da4bad4a182bfc2a762394650b627a882694c306"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "03bd8eecc5ed196021d8e3b5dd421b93534301c3f35516a5be73bf9f6edb4c8d" => :catalina
    sha256 "21d7b23e9032b646c1a9dee11418db15fce25122386affe61246c480bfeba986" => :x86_64_linux
  end

  depends_on :java => "1.8"
  depends_on "python"

  # uses_from_macos "python@2"

  resource "count_reads.bam" do
    url "https://github.com/broadinstitute/gatk/blob/626c88732c02b0fd5f395db20c91bf2784ec54b9/src/test/resources/org/broadinstitute/hellbender/tools/count_reads.bam?raw=true"
    sha256 "656e36331a39a3641565ef7810a529ac51270b4132007d7b94e6efff99133a2c"
  end

  def install
    prefix.install "gatk"
    prefix.install "scripts/dataproc-cluster-ui"
    prefix.install "gatk-package-#{version}-spark.jar"
    prefix.install "gatk-package-#{version}-local.jar"
    bash_completion.install "gatk-completion.sh"
    bin.find { |f| rewrite_shebang detected_python_shebang, f }
    bin.install_symlink "#{prefix}/gatk"
    bin.install_symlink "#{prefix}/dataproc-cluster-ui"
  end

  def caveats
    <<~EOS
      This brew installation does not include the necessary python dependencies to run certain gatk tools.
      Similarly, it does not install the necessary version of R and its packages for certain plotting functions to work.

      See the GATK readme for detailed installation instructions.
         https://github.com/broadinstitute/gatk

      The recommended way of running the tools with complex python dependencies is to use the pre-built docker images instead of attempting to install them locally.
      Gatk dockers are available on docker hub:
         https://hub.docker.com/r/broadinstitute/gatk/tags/
    EOS
  end
  test do
    assert_match "Usage", shell_output("#{bin}/gatk --help 2>&1")
    testpath.install resource("count_reads.bam")
    assert_equal "Tool returned:\n8",
                  shell_output("#{bin}/gatk CountReads -I count_reads.bam --tmp-dir #{testpath}").strip
  end
end
