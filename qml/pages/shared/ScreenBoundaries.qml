import Box2DStatic 2.0

/*
  This body places 32-pixel wide invisible static bodies around the root,
  to avoid stuff getting out.
*/
Body {
    world: physicsWorld

    Box {
        y: root.height
        width: root.width
        height: 32
    }
    Box {
        y: -32
        height: 32
        width: root.width
    }
    Box {
        x: -32
        width: 32
        height: root.height
    }
    Box {
        x: root.width
        width: 32
        height: root.height
    }
}
