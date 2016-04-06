# https://www.careercup.com/question?id=5749533368647680
#Input:
      #6
     #/ \
    #3   4
   #/ \   \
  #5   1   0
 #/ \     /
#9   2   8
     #\
      #7

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
