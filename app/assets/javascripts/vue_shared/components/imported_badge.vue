<script>
import { GlBadge, GlTooltipDirective } from '@gitlab/ui';
import { __, s__, sprintf } from '~/locale';

import { TYPE_EPIC, TYPE_ISSUE, TYPE_MERGE_REQUEST } from '~/issues/constants';
import { TYPE_DESIGN, TYPE_SNIPPET } from '~/import/constants';

const importableTypeText = {
  [TYPE_DESIGN]: __('design'),
  [TYPE_EPIC]: __('epic'),
  [TYPE_ISSUE]: __('issue'),
  [TYPE_MERGE_REQUEST]: __('merge request'),
  [TYPE_SNIPPET]: __('snippet'),
};

export default {
  components: {
    GlBadge,
  },
  directives: {
    GlTooltip: GlTooltipDirective,
  },
  props: {
    importableType: {
      type: String,
      required: false,
      default: '',
    },
    size: {
      type: String,
      required: false,
      default: undefined,
    },
  },
  computed: {
    title() {
      return sprintf(s__('BulkImport|This %{importable} was imported from another instance.'), {
        importable: importableTypeText[this.importableType],
      });
    },
  },
};
</script>

<template>
  <gl-badge v-gl-tooltip="title" :size="size">
    {{ __('Imported') }}
  </gl-badge>
</template>
