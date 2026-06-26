# ⚙️ 环境搭建

> 配置量化交易开发环境。

## Python 环境

建议使用 conda 管理 Python 环境：

```bash
conda create -n quant python=3.11
conda activate quant
```

## 安装常用库

```bash
pip install numpy pandas matplotlib seaborn
pip install jupyter notebook
pip install backtrader zipline  # 回测框架
pip install ta-lib              # 技术指标
```
