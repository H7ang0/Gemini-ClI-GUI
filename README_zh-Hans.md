# Gemini GUI

![Gemini GUI 截图占位符](screenshot.png) <!-- 截图占位符 -->

一个用于与 Gemini 命令行界面 (CLI) 交互的 macOS 原生图形用户界面 (GUI) 应用。此应用程序提供了一个用户友好的聊天界面，让您能够直接在桌面上利用 Gemini 的强大功能。

## 功能特性

*   **交互式聊天界面**：发送提示并接收 Gemini 的回复。
*   **对话历史记录**：所有对话都会自动保存和加载，并通过侧边栏进行访问。
*   **多对话支持**：创建、管理和切换多个聊天会话。
*   **自定义头像**：使用 SF Symbols 个性化您的用户和 Gemini 头像。
*   **触觉反馈**：当 Gemini 开始输入时，您的 MacBook 触控板会提供微妙的触觉反馈（可在设置中切换）。
*   **输入指示器**：当 Gemini 正在生成回复时，显示视觉指示器。
*   **中断生成**：中断 Gemini 正在进行的回复。
*   **复制消息**：轻松将 Gemini 的回复复制到剪贴板。
*   **回车发送**：按下回车键即可发送消息。
*   **自定义 Gemini CLI 路径**：在应用程序设置中配置 `gemini` 可执行文件的路径。
*   **本地化**：根据系统设置支持多种语言（英语、简体中文）。

## 系统要求

*   macOS（推荐最新版本）
*   Xcode（推荐最新稳定版本）
*   您的系统上已安装并配置 [Gemini CLI](https://github.com/google/google-gemini-cli)。

## 安装与设置

1.  **克隆仓库**：
    ```bash
    git clone https://github.com/H7ang0/GeminiGUI.git # 替换为您的实际仓库 URL
    cd GeminiGUI
    ```
2.  **在 Xcode 中打开**：
    在 Xcode 中打开 `GeminiGUI.xcodeproj` 文件。
3.  **禁用应用沙盒**：
    *   在 Xcode 中，选择左侧导航器中的项目 `GeminiGUI`。
    *   在主编辑区域，选择 `TARGETS` 下的 `GeminiGUI`。
    *   转到 **Signing & Capabilities** 标签页。
    *   找到 **App Sandbox** 并点击旁边的 `x`（移除）按钮。这是应用程序在沙盒外执行 `gemini` CLI 所必需的。
4.  **构建并运行**：
    构建并运行项目（`Cmd + R`）。
5.  **配置 Gemini CLI 路径**：
    *   应用程序启动后，转到 macOS 菜单栏中的 `GeminiGUI` -> `Settings...`。
    *   在“通用”部分，输入 `gemini` 可执行文件的完整路径（例如，`/opt/homebrew/bin/gemini`）。您可以在终端中输入 `which gemini` 来找到此路径。
    *   （可选）自定义您的头像和触觉反馈设置。

## 使用方法

*   **新建对话**：点击侧边栏中的 `+` 按钮开始新对话。
*   **选择对话**：点击侧边栏中的任意对话以查看其历史记录。
*   **发送消息**：在底部输入框中输入您的提示，然后按回车键或点击发送按钮。
*   **停止**：点击红色停止按钮以中断 Gemini 的回复。
*   **复制**：点击 Gemini 消息旁边的复制按钮以复制文本。

## 本地化

本应用程序支持：
*   英语 (English)
*   简体中文 (Simplified Chinese)

语言将自动跟随您的 macOS 系统语言设置。

## 鸣谢

由 [H7ang0](https://t.me/H7ang0) 开发

## 许可证

本项目采用 [MIT 许可证](LICENSE) 开源。<!-- 建议添加 LICENSE 文件 -->
