class RxnetPython < Formula
  version "1.1.2"
  include Language::Python::Virtualenv

  desc "Reactive synchronous runtime library — Python implementation"
  homepage "https://github.com/greenlsi/rxnet"
  url "https://github.com/greenlsi/rxnet/releases/download/v1.1.2/rxnet-1.1.2.tar.gz"
  sha256 "fad36833c77849acb1ad1e2fa12ec3b387fb9d1fc3d3b8304f531e0e59f9b835"
  license "GPL-3.0-or-later"

  depends_on "python@3.12"

  resource "types-pyyaml" do
    url "https://files.pythonhosted.org/packages/74/73/b759b1e413c31034cc01ecdfb96b38115d0ab4db55a752a3929f0cd449fd/types_pyyaml-6.0.12.20260408.tar.gz"
    sha256 "92a73f2b8d7f39ef392a38131f76b970f8c66e4c42b3125ae872b7c93b556307"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system python3, "-c", "import rxnet"
  end
end
