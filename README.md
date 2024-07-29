# AHD2-SimpleCartoonShading

<img alt="GitHub Release" src="https://img.shields.io/github/v/release/ahd2/AHD2-SimpleCartoonShading?style=for-the-badge"> <img alt="GitHub Release Date" src="https://img.shields.io/github/release-date/ahd2/AHD2-SimpleCartoonShading?style=for-the-badge"> <img alt="GitHub License" src="https://img.shields.io/github/license/ahd2/AHD2-SimpleCartoonShading?style=for-the-badge">

基于Unity URP的仿supercell风格的简单卡通着色器。

## 核心特点

* 基于Matcap的伪PBR，可以做出如金属，玻璃，塑料，石头等基本材质的卡通着色效果。
* 在默认设置下可达到和拾色器近乎一样的色彩。
* 支持光照贴图的烘焙和采样。
* 目前不支持Tonemapping后处理和HDR颜色。

## 安装

### 项目设置

不开启Tonemapping即可。在场景方向光颜色强度均为1，环境光照也为1，无其他灯光影响下。材质亮部颜色可与拾色器同步。

<p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/0.png?raw=true" alt="img" style="zoom:50%;" />
  </p>
  <p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/1.png?raw=true" alt="img" style="zoom: 50%;" />
  </p>
  <p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/2.png?raw=true" alt="1" style="zoom: 33%;" />
  </p>

### 导入

#### 通过URL导入

打开Unity Package Manager，通过URL添加。输入以下URL。

 <p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/3.png?raw=true" alt="1" style="zoom: 80%;" />
  </p>

https://github.com/ahd2/AHD2-SimpleCartoonShading.git

## 使用说明

### 材质创建

右键菜单中可创建材质。会自动设置默认Matcap贴图。也可后续自行更换。

 <p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/4.png?raw=true" alt="1" style="zoom: 80%;" />
  </p>

### 全局影响

当调整场景方向光颜色及强度时，会且仅会影响所有材质的亮部。

 <p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/5.png?raw=true" alt="1" style="zoom: 80%;" />
  </p>

当调整场景环境光时，会影响其全局色调。

 <p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/6.png?raw=true" alt="1" style="zoom: 80%;" />
  </p>

### 参数说明

#### 基础色

贴图和基础色，决定材质的基础颜色。

 <p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/7.png?raw=true" alt="1" style="zoom: 80%;" />
  </p>

#### 伪PBR

##### 金属度

 <p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/8.png?raw=true" alt="1" style="zoom: 80%;" />
  </p>

Metalness决定金属matcap贴图的明显程度。（下图中从左到右，Metalness递增，金属度亮度全为1）

<p align="center">
    <img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/9.png?raw=true" alt="1" style="zoom: 80%;" />
  </p>

金属度亮度决定金属matcap贴图的亮度。（下图中从左到右，金属度亮度递增，Metalness全为1）

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/10.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

推荐调整金属质感的时候可以两个参数结合调整。

##### 光滑度

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/11.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

Roughness决定RoughnessCap贴图的明显程度。（下图中从左到右，Roughness递增，粗糙度亮度全为0.27（推荐值））

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/12.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

粗糙度亮度决定RoughnessCap贴图的亮度。（下图中从左到右，粗糙度亮度递增，Roughness全为1）

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/13.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

##### 菲涅尔

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/14.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

菲涅尔范围决定菲涅尔的范围。（下图中从左到右，范围递增）

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/15.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

##### 法线贴图

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/16.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

#### 阴影

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/17.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

阴影浓度，决定阴影的亮度。（下图从左到右阴影浓度递增，阴影过度阈值均为0.8）

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/18.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

阴影过度阈值，决定阴影的软硬。（下图从左到右过渡阈值递增，浓度均为0.5）

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/19.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

### 光照烘焙

<p align="center">
<img src="https://github.com/ahd2/AHD2-DocsRepo/blob/main/AHD2_SimpleCartoonShading/20.png?raw=true" alt="1" style="zoom: 80%;" />
</p>

支持光照烘焙贡献GI与光照贴图采样。
