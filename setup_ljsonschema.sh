#!/bin/bash

# ljsonschema 开发环境配置脚本
# Development environment setup script for ljsonschema

echo "=== ljsonschema 开发环境配置 ==="

# 检查必要工具
echo "1. 检查基础工具..."
command -v lua >/dev/null 2>&1 || { echo "错误: 需要安装 Lua" >&2; exit 1; }
command -v luarocks >/dev/null 2>&1 || { echo "错误: 需要安装 LuaRocks" >&2; exit 1; }

echo "   ✓ Lua 版本: $(lua -v)"
echo "   ✓ LuaRocks 版本: $(luarocks --version | head -n1)"

# 安装依赖
echo "2. 安装项目依赖..."
luarocks install net-url || echo "   net-url 可能已安装"
luarocks install lua-cjson || echo "   lua-cjson 可能已安装"
luarocks install https://raw.githubusercontent.com/jdesgats/telescope/master/rockspecs/telescope-scm-1.rockspec || echo "   telescope 可能已安装"

# 初始化子模块
echo "3. 初始化测试套件子模块..."
git submodule update --init --recursive

# 安装项目
echo "4. 安装 ljsonschema 到本地环境..."
luarocks make

# 运行完整测试套件
echo "5. 运行完整测试套件..."
tsc ./spec/suite.lua

echo ""
echo "=== 开发环境配置完成 ==="
echo ""
echo "开发指南："
echo "1. 主要代码文件位于 jsonschema/ 目录"
echo "2. 测试文件位于 spec/ 目录"
echo "3. 运行完整测试套件: tsc ./spec/suite.lua"
echo "4. 测试套件包含 JSON Schema Draft 4 的官方测试用例"
echo ""
echo "常用命令："
echo "- 重新安装项目: luarocks make"
echo "- 运行完整测试: tsc ./spec/suite.lua"
echo "- 查看模块路径: luarocks path"
echo ""