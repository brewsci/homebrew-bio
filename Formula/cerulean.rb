class Cerulean < Formula
  # cite Deshpande_2013 "https://doi.org/10.1007/978-3-642-40453-5_27"
  desc "Extend contigs assembled using short reads using long reads"
  homepage "https://sourceforge.net/projects/ceruleanassembler/"
  url "https://downloads.sourceforge.net/project/ceruleanassembler/Cerulean_v_0_1.tar.gz"
  sha256 "b6b9046fb1cf9980a169ccfe1a57c1060c6afbbe12e6b201eb8c47be0849b688"

  depends_on "numpy"
  depends_on "abyss" => :recommended

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/39/8d/6c1a955dd402e306e55e6c63b9ae8edf618f8530ccc8979290dbb84022db/kiwisolver-1.0.1-cp27-cp27m-manylinux1_x86_64.whl"
    sha256 "e0f910f84b35c36a3513b96d816e6442ae138862257ae18a0019d2fc67b041dc"
  end

  def install
    doc.install "README"
    libexec.install Dir["src/*"]
    prefix.install "data"
  end

  test do
    system "python", "#{libexec}/Cerulean.py", "-h"
  end
end
