require('quicker').setup({
  keys = {
    {
      '>',
      function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
      desc = 'Expand quickfix context',
    },
    {
      '<',
      function() require('quicker').collapse() end,
      desc = 'Collapse quickfix context',
    },
  },
})

Leadermap({ 'xl', function() require('quicker').toggle({ loclist = true }) end, desc = 'Location List' })
Leadermap({ 'xq', require('quicker').toggle, desc = 'Quickfix List' })
