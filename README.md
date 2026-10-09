# Gigi 2D Radiance Cascades technique

"Radiance Cascades" is a very clever technique to propagate lighting efficiently and with high quality.
It works best in 2D and this is a simple real-time implantation with basic optimizations.
See the paper by Alexander Sannikov for more details. This is a HLSL implementation running in Gigi
It is a interactive, you can paint occluders or emissive objects with the mouse.
There are no materials (diffuse, specular, subsurface, refractive) and no multiple bounces yet.

<img width="1227" height="724" alt="image" src="https://github.com/user-attachments/assets/6cef8275-d957-486c-bd9e-72426a03b1f9" />

Radiance Cascades:
* Paper
  [link](https://drive.google.com/file/d/1L6v1_7HY2X-LV3Ofb6oyTIxgEaP4LOI6/view)
* Exilecon 2019 (Alexander Sannikov)
  [link](https://www.youtube.com/watch?v=whyJzrVEgVc)

Gigi (DirectX shader playground):
* GitHub [link](https://github.com/electronicarts/gigi)

More links:
* Exploration and Optimization of Radiance Cascades for Real-Time Applications
  [link](https://odr.chalmers.se/items/3ee9fb4e-1880-46c2-802a-a660e38dc9ee)
* Radiance Cascades: A Novel High-Resolution Formal Solution for Multidimensional Non-LTE Radiative Transfer
  [link](https://arxiv.org/pdf/2408.14425)
* Building Real-Time Global Illumination Radiance Cascades (online demo and tutorial)
  [link](https://jason.today/rc?pixelRatio=1)
* Refracting Radiance Cascades
  [link](https://www.youtube.com/watch?v=N6hcS7Ub2pU)
* 2D global illumination with radiance cascades at ~0.3 ms per frame
  [link](https://www.youtube.com/watch?v=6O9-BUDk_-c)
