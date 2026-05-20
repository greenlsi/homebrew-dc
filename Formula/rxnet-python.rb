class RxnetPython < Formula
  version "1.1.3"
  include Language::Python::Virtualenv

  desc "Reactive synchronous runtime library — Python implementation"
  homepage "https://github.com/greenlsi/rxnet"
  url "https://github.com/greenlsi/rxnet/releases/download/v1.1.3/rxnet-1.1.3.tar.gz"
  sha256 "a36fe7c824bd3f79fc01deca3b94e12d5364535e9a9cddd431cea25f0774e9e1"
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
