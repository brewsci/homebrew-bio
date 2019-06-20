class Apbspdb2pqr < Formula
  include Language::Python::Virtualenv
  # cite Jurrus_2018: "https://doi.org/10.1002/pro.3280"
  # cite Baker_2001: "https://doi.org/10.1073/pnas.181342398"
  desc "Electrostatic and solvation properties for complex molecules"
  homepage "https://www.poissonboltzmann.org/"
  # pull from git tag to get submodules
  url "https://github.com/Electrostatics/apbs-pdb2pqr.git",
      :tag      => "apbs-1.5",
      :revision => "aa353941cfadc09ccd113075d261a427864c2979"
  head "https://github.com/Electrostatics/apbs-pdb2pqr.git"

  bottle do
    cellar :any
    sha256 "20632b132bd4b3f2d5b76810b20d95a2980071f870957273b5d803a78586ef50" => :sierra
    sha256 "0a100baae07f10c659ce97c7750fe610fefe57bc84067e0d0fdccf5fa7cac09b" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "python"
  depends_on "python@2"
  depends_on "swig"

  def install
    # APBS part
    # Disable GEOFLOW, FETK, and PBAM because their installation were failed on Linux...
    cd "apbs" do
      mkdir "build" do
        args = std_cmake_args + %w[
          -DCMAKE_POLICY_DEFAULT_CMP0046=OLD
          -DCMAKE_POLICY_DEFAULT_CMP0078=OLD
          -DCMAKE_POLICY_DEFAULT_CMP0086=OLD
          -DENABLE_GEOFLOW=OFF
          -DENABLE_FETK=OFF
          -DENABLE_PBAM=OFF
          -DGET_MSMS=ON
          -DGET_NanoShaper=ON
          -DENABLE_PYTHON=ON
          -DBUILD_DOC=OFF
          -DCMAKE_BUILD_TYPE=Release
        ]
        args << "-DBUILD_SHARED_LIBS=ON" if OS.linux?
        system "cmake", "..", *args
        system "make", "install"
      end
    end

    # PDB2PQR part
    cd "pdb2pqr" do
      inreplace "pdb2pqr.py.in", "@WHICHPYTHON@", "/usr/bin/env python"
      system "python", "scons/scons.py", "PREFIX=#{prefix}/pdb2pqr", "APBS=#{bin}/apbs", "BUILD_PDB2PKA=False"
      system "python", "scons/scons.py", "install"
      cp_r %w[main.py main_cgi.py pka.py visualize.py AppService_types.py AppService_services_types.py AppService_services.py AppService_client.py], prefix/"pdb2pqr"
      cp_r Dir["*"], prefix/"pdb2pqr"
      ln_s prefix/"pdb2pqr/pdb2pqr.py", bin/"pdb2pqr"
    end
  end

  test do
    # APBS test
    cd prefix/"share/apbs/examples/solv" do
      system bin/"apbs", "apbs-mol.in"
    end
    # PDB2PQR test
    system bin/"pdb2pqr", "--ff=amber", prefix/"pdb2pqr/tests/pdb2pka-test/1a1p/1a1p.pdb", "foo.pqr"
  end
end
