# frozen_string_literal: true

require "optparse"
require "tty-prompt"
require "json"
require "aws-sdk-ecs"

module Ecsl
  # ECS Exec command helper
  class Exec
    def initialize
      @profile = nil
      @filter = nil
      @region = nil
      @prompt = TTY::Prompt.new(interrupt: :exit)
      @ecs_client = nil
      parse_options
    end

    def run
      cluster = select_cluster
      task, container = select_service_and_container(cluster)

      command = [
        "aws", "--profile", @profile, "--region", @region, "ecs", "execute-command",
        "--cluster", cluster, "--task", task, "--container", container,
        "--interactive", "--command", "/bin/bash"
      ].join(" ")
      puts command
    end

    private

    def parse_options
      OptionParser.new do |opts|
        opts.on("-p", "--profile PROFILE", "AWS profile") { |v| @profile = v }
        opts.on("-f", "--filter FILTER", "Filter cluster name") { |v| @filter = v }
        opts.on("-r", "--region REGION", "AWS region") { |v| @region = v }
      end.parse!
    end

    def ecs_client
      @ecs_client ||= Aws::ECS::Client.new(
        profile: @profile,
        region: @region
      )
    end

    def list_clusters
      clusters = ecs_client.list_clusters.cluster_arns
      clusters.map { |arn| arn.split("/").last }
    end

    def list_services(cluster)
      services = ecs_client.list_services(cluster: cluster).service_arns
      services.map { |arn| arn.split("/").last }
    end

    def list_tasks(cluster, service)
      tasks = ecs_client.list_tasks(
        cluster: cluster,
        service_name: service
      ).task_arns
      tasks.map { |arn| arn.split("/").last }
    end

    def list_containers(cluster, task)
      containers = ecs_client.describe_tasks(
        cluster: cluster,
        tasks: [task]
      ).tasks.first.containers
      containers.map(&:name)
    end

    def select_or_auto(items, message)
      return items.first if items.size == 1

      @prompt.select(message, items.sort, filter: true)
    end

    def select_cluster
      clusters = list_clusters
      clusters = clusters.select { |c| c.include?(@filter) } if @filter
      raise Error, "No clusters found" if clusters.empty?

      select_or_auto(clusters, "Select a cluster:")
    end

    def select_service_and_container(cluster)
      services = list_services(cluster)
      raise Error, "No services found" if services.empty?

      service = select_or_auto(services, "Select a service:")

      tasks = list_tasks(cluster, service)
      raise Error, "No tasks found" if tasks.empty?

      task = select_or_auto(tasks, "Select a task:")

      containers = list_containers(cluster, task)
      raise Error, "No containers found" if containers.empty?

      container = select_or_auto(containers, "Select a container:")

      [task, container]
    end
  end
end
