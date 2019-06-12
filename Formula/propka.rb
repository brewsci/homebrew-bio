class Propka < Formula
  # cite Sondergaard_2011: "https://doi.org/10.1021/ct200133y"
  # cite Olsson_2011: "https://doi.org/10.1021/ct100578z"
  desc "Predict pKa values of ionizable groups in protein-ligand complexes"
  homepage "http://propka.org/"
  url "https://files.pythonhosted.org/packages/a3/7b/e935ce37cbf9ac8fe23ec05f8072fb3a63582b20fb01ef0c24502b5d10ba/PROPKA-3.1.0.tar.gz"
  sha256 "ada690067c5ad9ca6be412491380929e5275fa41166aa1fb2c820fcc2dfdb619"

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"../lib/python#{xy}/site-packages"

    args << "--jobs=4" if ENV["CIRCLECI"]
    system "python#{xy}", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "#{bin}/propka31", "-h"
  end
end
