module TreeData
  def fb_tree
    Node.new(
      value: 6,
      left: Node.new(
        value: 3,
        left: Node.new(
          value: 5,
          left: Node.new(
            value: 9
          ),
          right: Node.new(
            value: 2,
            right: Node.new(
              value: 7
            )
          )
        ),
        right: Node.new(
          value: 1
        )
      ),
      right: Node.new(
        value: 4,
        right: Node.new(
          value: 0,
          left: Node.new(
            value: 8
          )
        )
      )
    )
  end
end
