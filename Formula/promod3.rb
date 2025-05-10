class Promod3 < Formula
  include Language::Python::Virtualenv

  # cite Studer_2021: "https://doi.org/10.1371/journal.pcbi.1008667"
  desc "Versatile Homology Modelling Toolbox"
  homepage "https://openstructure.org/promod3"
  url "https://git.scicore.unibas.ch/schwede/ProMod3/-/archive/3.4.2/ProMod3-3.4.2.tar.gz"
  sha256 "8103bcb344489eb0fa0567ad8c9a8a9b42d3dbbb8d46c82587e6a58eab45eefd"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/openmm@7"
  depends_on "brewsci/bio/openstructure"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    if OS.mac?
      ENV.prepend "LDFLAGS", "-undefined dynamic_lookup -Wl,-export_dynamic"

      # Disable linking directly to CPython shared libraries
      inreplace "cmake_support/PROMOD3.cmake",
        /^\s*set\(CMAKE_REQUIRED_FLAGS "\$\{CMAKE_REQUIRED_FLAGS\} \$\{Python_LIBRARIES\}"\)\n?/, ""
      inreplace "cmake_support/PROMOD3.cmake", /\s*\$\{Python_LIBRARIES\}\s*/, " "

    elsif OS.linux?
      ENV.prepend "LDFLAGS", "-Wl,--allow-shlib-undefined,--export-dynamic -lstdc++"
    end

    inreplace "CMakeLists.txt", "find_package(Python 3.6", "find_package(Python 3"

    # Install promod3 to virtualenv
    venv = virtualenv_create libexec, which(python3)
    ENV.prepend_path "PATH", libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", venv.site_packages
    site_packages_path = Language::Python.site_packages python3
    (prefix/site_packages_path/"homebrew-promod3.pth").write venv.site_packages

    mkdir "build" do
      cmake_args = std_cmake_args + %W[
        -DCMAKE_CXX_STANDARD=11
        -DOST_ROOT=#{Formula["openstructure"].opt_prefix}
        -DOPTIMIZE=ON
        -DDISABLE_DOCUMENTATION=ON
      ]
      cmake_args << "-DENABLE_SSE=ON" if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "pm <action>", shell_output("#{bin}/pm 2>&1", 1)

    (testpath/"gen_pdb.py").write <<~EOS
      from ost import io
      from promod3 import loop

      sequence = "HELLYEAH"
      bb_list = loop.BackboneList(sequence)
      io.SavePDB(bb_list.ToEntity(), "test.pdb")
    EOS

    system libexec/"bin/python", "gen_pdb.py"
    assert_match(/^ATOM\s+3\s+C\s+HIS\s+A\s+/, (testpath/"test.pdb").read)
  end
end
