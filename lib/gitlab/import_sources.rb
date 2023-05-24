# frozen_string_literal: true

# Gitlab::ImportSources module
#
# Define import sources that can be used
# during the creation of new project
#
module Gitlab
  module ImportSources
    ImportSource = Struct.new(:name, :title, :importer)

    # We exclude `bare_repository` here as it has no import class associated
    IMPORT_TABLE = [
      ImportSource.new('github',           'GitHub',            Gitlab::GithubImport::ParallelImporter),
      ImportSource.new('bitbucket',        'Bitbucket Cloud',   Gitlab::BitbucketImport::Importer),
      ImportSource.new('bitbucket_server', 'Bitbucket Server',  Gitlab::BitbucketServerImport::ParallelImporter),
      ImportSource.new('gitlab',           'GitLab.com',        Gitlab::GitlabImport::Importer),
      ImportSource.new('fogbugz',          'FogBugz',           Gitlab::FogbugzImport::Importer),
      ImportSource.new('git',              'Repository by URL', nil),
      ImportSource.new('gitlab_project',   'GitLab export',     Gitlab::ImportExport::Importer),
      ImportSource.new('gitea',            'Gitea',             Gitlab::LegacyGithubImport::Importer),
      ImportSource.new('manifest',         'Manifest file',     nil),
      ImportSource.new('phabricator',      'Phabricator',       Gitlab::PhabricatorImport::Importer)
    ].freeze

    LEGACY_IMPORT_TABLE = IMPORT_TABLE.deep_dup
    LEGACY_IMPORT_TABLE[2].importer = Gitlab::BitbucketServerImport::Importer

    class << self
      prepend_mod_with('Gitlab::ImportSources') # rubocop: disable Cop/InjectEnterpriseEditionModule

      def options
        import_table.to_h { |importer| [importer.title, importer.name] }
      end

      def values
        IMPORT_TABLE.map(&:name)
      end

      def importer_names
        import_table.select(&:importer).map(&:name)
      end

      def importer(name)
        import_table.find { |import_source| import_source.name == name }.importer
      end

      def title(name)
        options.key(name)
      end

      def import_table
        return IMPORT_TABLE if Feature.enabled?(:bitbucket_server_parallel_importer)

        LEGACY_IMPORT_TABLE
      end
    end
  end
end
